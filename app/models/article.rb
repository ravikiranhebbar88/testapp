class Article < ActiveRecord::Base
	include Bootsy::Container
	validates :title, presence: true, length: {minimum: 3, maximum: 20}
	validates :description, presence:true, length: {minimum: 5}
end
