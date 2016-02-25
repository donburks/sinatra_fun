class User < ActiveRecord::Base
	validates :username, length: {minimum: 3}
end
