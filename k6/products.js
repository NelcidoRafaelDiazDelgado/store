import http from "k6/http";
import { check, sleep } from "k6";
import { Trend, Rate, Counter } from "k6/metrics";

const BASE_URL = __ENV.BASE_URL || "http://rails-app:3000";
console.log(__ENV.BASE_URL)

const indexDuration = new Trend("products_index_duration", true);
const searchDuration = new Trend("products_search_duration", true);
const paginationDuration = new Trend("products_pagination_duration", true);
const showDuration = new Trend("products_show_duration", true);
const createDuration = new Trend("products_create_duration", true);
const updateDuration = new Trend("products_update_duration", true);
const deleteDuration = new Trend("products_delete_duration", true);

const errorRate = new Rate("products_errors");
const requests = new Counter("products_requests");

export const options = {
  scenarios: {
    products_read: {
      executor: "constant-vus",
      vus: 10,
      duration: "30s",
      exec: "readProducts",
    },

    products_search: {
      executor: "constant-vus",
      vus: 5,
      duration: "30s",
      startTime: "5s",
      exec: "searchProducts",
    },

    products_pagination: {
      executor: "constant-vus",
      vus: 5,
      duration: "30s",
      startTime: "10s",
      exec: "paginationProducts",
    },

    products_show: {
      executor: "constant-vus",
      vus: 5,
      duration: "30s",
      startTime: "15s",
      exec: "showProduct",
    },
  },

  thresholds: {
    http_req_failed: ["rate<0.01"],

    products_index_duration: [
      "p(95)<500",
      "p(99)<1000",
    ],

    products_search_duration: [
      "p(95)<800",
      "p(99)<1500",
    ],

    products_pagination_duration: [
      "p(95)<500",
      "p(99)<1000",
    ],

    products_show_duration: [
      "p(95)<300",
      "p(99)<500",
    ],

    products_errors: [
      "rate<0.01",
    ],
  },
};

const params = {
  headers: {
    Accept: "application/json",
    "Content-Type": "application/json",
  },
};

function validate(response, name) {
  requests.add(1);

  const success = check(response, {
    [`${name} status 200`]: (r) => r.status === 200,
    [`${name} response time < 1s`]: (r) => r.timings.duration < 1000,
  });

  errorRate.add(!success);

  return success;
}

/**
 * GET /products.json
 */
export function readProducts() {
  const response = http.get(
    `${BASE_URL}/products.json?limit=20`,
    params
  );

  indexDuration.add(response.timings.duration);

  validate(response, "products index");

  sleep(1);
}

/**
 * GET /products.json
 *
 * Search:
 * name ILIKE '%term%'
 * OR description ILIKE '%term%'
 */
export function searchProducts() {
  const searchTerms = [
    "phone",
    "laptop",
    "computer",
    "keyboard",
    "mouse",
  ];

  const term = searchTerms[
    Math.floor(Math.random() * searchTerms.length)
  ];

  const response = http.get(
    `${BASE_URL}/products.json?search=${encodeURIComponent(term)}&limit=20`,
    params
  );

  searchDuration.add(response.timings.duration);

  validate(response, "products search");

  sleep(1);
}

/**
 * GET /products.json
 *
 * Prueba OFFSET + LIMIT.
 */
export function paginationProducts() {
  const offsets = [
    0,
    20,
    100,
    500,
    1000,
    5000,
    10000,
  ];

  const offset = offsets[
    Math.floor(Math.random() * offsets.length)
  ];

  const response = http.get(
    `${BASE_URL}/products.json?offset=${offset}&limit=20`,
    params
  );

  paginationDuration.add(response.timings.duration);

  validate(response, `pagination offset=${offset}`);

  sleep(1);
}

/**
 * GET /products/:id.json
 *
 * IMPORTANTE:
 * Cambia este ID por uno existente.
 */
export function showProduct() {
  const productId = __ENV.PRODUCT_ID || "1";

  const response = http.get(
    `${BASE_URL}/products/${productId}.json`,
    params
  );

  showDuration.add(response.timings.duration);

  const success = check(response, {
    "show status 200": (r) => r.status === 200,
  });

  errorRate.add(!success);

  requests.add(1);

  sleep(1);
}