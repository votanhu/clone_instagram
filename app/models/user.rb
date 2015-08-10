class User < ActiveRecord::Base
	validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
	validates :website, allow_blank: true, :format => URI::regexp(%w(http https))
	validates :username, presence: true, uniqueness: true
	validates :email, uniqueness: true
end
