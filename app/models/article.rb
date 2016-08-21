class Article < ActiveRecord::Base
	include Bootsy::Container
	has_many :article_tags, :dependent => :destroy
    has_many :tags, :through => :article_tags
	validates :title, presence: true, length: {minimum: 3, maximum: 20}
	validates :description, presence:true, length: {minimum: 5}
end
