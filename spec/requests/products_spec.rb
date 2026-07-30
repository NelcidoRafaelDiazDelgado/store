require 'swagger_helper'

RSpec.describe 'Products API', type: :request do
  path '/products' do
    get('list products') do
      tags 'Products'
      produces 'application/json'

      parameter name: :offset,
                in: :query,
                required: false,
                type: :integer,
                default: 0,
                description: 'Number of products to skip'

      parameter name: :limit,
                in: :query,
                required: false,
                type: :integer,
                default: 20,
                description: 'Maximum number of products to return'

      parameter name: :search,
                in: :query,
                required: false,
                type: :string,
                description: 'Search by product name or description'

      parameter name: :sort,
                in: :query,
                required: false,
                type: :string,
                enum: %w[created_at price name],
                default: 'created_at',
                description: 'Column used to sort the products'

      parameter name: :direction,
                in: :query,
                required: false,
                type: :string,
                enum: %w[asc desc],
                default: 'desc',
                description: 'Sort direction'

      response(200, 'successful') do
        let(:offset) { 0 }
        let(:limit) { 20 }
        let(:search) { nil }
        let(:sort) { 'created_at' }
        let(:direction) { 'desc' }

        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   name: { type: :string },
                   description: { type: :string, nullable: true },
                   amount: { type: :number },
                   min: { type: :number },
                   price: { type: :number },
                   status: { type: :string },
                   sku: { type: :string },
                   created_at: { type: :string, format: :'date-time' },
                   updated_at: { type: :string, format: :'date-time' }
                 }
               }

        run_test!
      end
    end

    post('create product') do
      tags 'Products'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :product,
                in: :body,
                required: true,
                schema: {
                  type: :object,
                  required: %w[name description amount min price status sku],
                  properties: {
                    name: { type: :string, example: 'Laptop' },
                    description: { type: :string, example: 'Gaming laptop' },
                    amount: { type: :number, example: 10 },
                    min: { type: :number, example: 2 },
                    price: { type: :number, example: 1299.99 },
                    status: { type: :string, example: 'active' },
                    sku: { type: :string, example: 'LAP-001' }
                  }
                }

      response(201, 'product created') do
        let(:product) do
          {
            name: 'Laptop',
            description: 'Gaming laptop',
            amount: 10,
            min: 2,
            price: 1299.99,
            status: 'active',
            sku: 'LAP-001'
          }
        end

        run_test!
      end

      response(422, 'invalid product') do
        let(:product) do
          {
            name: '',
            description: 'Invalid product',
            amount: 0,
            min: 0,
            price: 0,
            status: 'active',
            sku: ''
          }
        end

        run_test!
      end
    end
  end

  path '/products/new' do
    get('new product') do
      tags 'Products'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :object

        run_test!
      end
    end
  end

  path '/products/{id}/edit' do
    parameter name: :id,
              in: :path,
              type: :string,
              format: :uuid,
              required: true,
              description: 'Product ID'

    get('edit product') do
      tags 'Products'
      produces 'application/json'

      response(200, 'successful') do
        let(:id) { '1' }

        schema type: :object,
               properties: {
                 id: {  type: :integer },
                 name: { type: :string },
                 description: { type: :string },
                 amount: { type: :number },
                 min: { type: :number },
                 price: { type: :number },
                 status: { type: :string },
                 sku: { type: :string }
               }

        run_test!
      end

      response(404, 'product not found') do
        let(:id) { '1' }

        run_test!
      end
    end
  end

  path '/products/{id}' do
    parameter name: :id,
              in: :path,
              type: :string,
              format: :uuid,
              required: true,
              description: 'Product ID'

    get('show product') do
      tags 'Products'
      produces 'application/json'

      response(200, 'successful') do
        let(:id) { '1' }

        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 description: { type: :string },
                 amount: { type: :number },
                 min: { type: :number },
                 price: { type: :number },
                 status: { type: :string },
                 sku: { type: :string },
                 created_at: { type: :string, format: :'date-time' },
                 updated_at: { type: :string, format: :'date-time' }
               }

        run_test!
      end

      response(404, 'product not found') do
        let(:id) { '1' }

        run_test!
      end
    end

    patch('update product') do
      tags 'Products'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :product,
                in: :body,
                required: true,
                schema: {
                  type: :object,
                  properties: {
                    name: { type: :string },
                    description: { type: :string },
                    amount: { type: :number },
                    min: { type: :number },
                    price: { type: :number },
                    status: { type: :string },
                    sku: { type: :string }
                  }
                }

      response(200, 'product updated') do
        let(:id) { '1' }

        let(:product) do
          {
            name: 'Updated Laptop',
            price: 1499.99
          }
        end

        run_test!
      end

      response(404, 'product not found') do
        let(:id) { '1' }

        let(:product) do
          {
            name: 'Updated Laptop'
          }
        end

        run_test!
      end

      response(422, 'invalid product') do
        let(:id) { '1' }

        let(:product) do
          {
            name: ''
          }
        end

        run_test!
      end
    end

    put('update product') do
      tags 'Products'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :product,
                in: :body,
                required: true,
                schema: {
                  type: :object,
                  required: %w[name description amount min price status sku],
                  properties: {
                    name: { type: :string },
                    description: { type: :string },
                    amount: { type: :number },
                    min: { type: :number },
                    price: { type: :number },
                    status: { type: :string },
                    sku: { type: :string }
                  }
                }

      response(200, 'product updated') do
        let(:id) { '1' }

        let(:product) do
          {
            name: 'Updated Laptop',
            description: 'Updated description',
            amount: 20,
            min: 5,
            price: 1499.99,
            status: 'active',
            sku: 'LAP-001'
          }
        end

        run_test!
      end
    end

    delete('delete product') do
      tags 'Products'
      produces 'application/json'

      response(204, 'product deleted') do
        let(:id) { '1' }

        run_test!
      end

      response(404, 'product not found') do
        let(:id) { '1' }

        run_test!
      end
    end
  end
end
