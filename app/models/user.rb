# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#  remember_token  :string(255)
#

class User < ActiveRecord::Base
	# ALWAYS include attr_accessible to enumerate the fields that are allowed to 
	# be set from an input form; those not listed will not be set-able by 'mass assigment':
	attr_accessible :name, :email, :password, :password_confirmation
	has_secure_password
	before_save :create_remember_token
	validates :name, presence: true, length: { maximum: 128 }
	valid_email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, format: { with: valid_email_regex },
                    uniqueness: { case_sensitive: false }
    # secure_password.rb already checks for presence of :password_digest
    # so we can assume that a password is present if that validation passes
    # and thus, we don't need to explicitly check for presence of password
    validates :password, 
             :length => { :minimum => 6 }, :if => :password_digest_changed?

	# secure_password.rb also checks for confirmation of :password 
	# but we also have to check for presence of :password_confirmation
	validates :password_confirmation, 
				:presence=>true, :if => :password_digest_changed?

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

end
