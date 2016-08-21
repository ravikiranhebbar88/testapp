class Tag < ActiveRecord::Base
    validates :name,presence: true,uniqueness: true
	has_many :article_tags,:dependent => :destroy
    has_many :articles, through: :article_tags
end
