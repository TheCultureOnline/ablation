# frozen_string_literal: true

class User < ApplicationRecord
  enum role: [:user, :member, :poweruser, :artist, :donor, :elite, :moderator, :admin]
  after_initialize :set_default_role, if: :new_record?
  after_initialize :setup_torrent_pass, if: :new_record?
  after_initialize :set_default_upload, if: :new_record?
  has_many :peers
  has_many :torrents, through: :peers

  def set_default_role
    self.role ||= :user
  end

  def set_default_upload
    self.bonus_upload ||= Setting.free_upload
  end

  def setup_torrent_pass
    self.torrent_pass = SecureRandom.hex(24)
  end

  def ratio
    if downloaded == 0
      Float::INFINITY
    else
      uploaded / downloaded
    end
  end

  def self.update_stats!
    query = "UPDATE users
    SET uploaded = stats.uploaded + COALESCE(users.bonus_upload, 0),
        downloaded = stats.downloaded
    FROM (
        SELECT  user_id,
                SUM(uploaded) AS uploaded,
                SUM(downloaded) AS downloaded
        FROM peers
        GROUP BY user_id
    ) AS stats
    WHERE stats.user_id = users.id
    RETURNING users.id"
    ActiveRecord::Base.connection.execute(query)
  end
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, authentication_keys: [:username]

  validates :username,
         presence: true,
         uniqueness: {
           case_sensitive: false
         }

  def includes?(target_role)
    if User.roles.include? target_role
      User.roles[self.role] >= User.roles[target_role]
    else
      false
    end
  end

  def self.can?(user, target_role)
    user && user.includes?(target_role)
  end
end
