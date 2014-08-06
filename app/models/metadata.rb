class Metadata
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Search
 
end
