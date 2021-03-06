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
#  admin           :boolean         default(FALSE)
#

class User < ActiveRecord::Base
	# ALWAYS include attr_accessible to enumerate the fields that are allowed to 
	# be set from an input form; those not listed will not be set-able by 'mass assigment':
	attr_accessible :name, :email, :password, :password_confirmation
	has_secure_password
	has_many :microposts, dependent: :destroy
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
	has_many :followers, through: :reverse_relationships, source: :follower

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

  def feed
    # This is preliminary. See "Following users" for the full implementation.
    Micropost.where("user_id = ?", id)
  end

  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

end
