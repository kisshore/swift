class Metadata
  include Mongoid::Document
  
  field :cotainer_name, type: String
  field :account_name, type: String
  field :object_meta, type: String
end
