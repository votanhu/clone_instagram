class Follow < ActiveRecord::Base
	validates_uniqueness_of :id_user, :scope => :id_follower
end
