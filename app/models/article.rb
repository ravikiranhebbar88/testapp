class Article < ActiveRecord::Base
	include Bootsy::Container
	has_many :article_tags, :dependent => :destroy
    has_many :tags, :through => :article_tags
    belongs_to :user
	validates :title, presence: true, length: {minimum: 3, maximum: 20},uniqueness: true
	validates :description, presence:true, length: {minimum: 5}

	before_create :title_permalink
	before_update :title_permalink

    def to_param
    	"#{id}-#{permalink}"
    end	

    def title_permalink
       self.permalink = title.downcase.gsub(/\s+/,'-').gsub(/[^a-zA-Z0-9_]+/,'-')
    end	

end
