module Locomotive
  module Concerns
    module Site
      module Metafields

        extend ActiveSupport::Concern

        included do

          ## fields ##
          field :metafields,        type: Hash
          field :metafields_schema, type: Array

          ## validations ##
          validate :validate_metafields_schema

        end

        def metafields_schema=(schema)
          super(schema.is_a?(String) ? ActiveSupport::JSON.decode(schema) : schema)
        end

        def metafields=(values)
          super(values.is_a?(String) ? ActiveSupport::JSON.decode(values) : values)
        end

        protected

        def validate_metafields_schema
          return if metafields_schema.blank?

          begin
            JSON::Validator.validate!(metafields_schema_schema, metafields_schema)
          rescue JSON::Schema::ValidationError
            self.errors.add(:metafields_schema, $!.message)
          end
        end

        def metafields_schema_schema
          {
            'id' => 'http://locomotive.works/schemas/metafields.json',
            'definitions' => {
              'field' => {
                'type' => 'object',
                'properties' => {
                  'name' => { 'type' => 'string' },
                  'label' => { 'type' => ['string', 'object'] },
                  'type' => { 'enum': ['string', 'text', 'integer', 'file', 'image', 'boolean', 'select'] },
                  'position' => { 'type' => 'integer' },
                  'select_options' => { 'type' => 'object' }
                },
                'required' => ['name']
              }
            },
            'type' => 'array',
            'items' => {
              'type' => 'object',
              'properties' => {
                  'label'     => { 'type' => ['string', 'object'] },
                  'fields'    => { 'type' => 'array', 'items': {'$ref': '#/definitions/field' } },
                  'position'  => { 'type' => 'integer', 'minimum' => 0 }
                },
              'required' => ['label', 'fields']
            }
          }
        end

      end

    end
  end
end
