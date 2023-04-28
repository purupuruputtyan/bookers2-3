class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  #bookモデルとのアソシエーション
  has_many :books, dependent: :destroy
  has_one_attached :profile_image

  #favoriteモデルとのアソシエーション
  has_many :favorites, dependent: :destroy
  has_many :favorite_books, through: :favorites, source: :book
  
  #book_commentモデルとのアソシエーション
  has_many :book_comments, dependent: :destroy

  #フォロー機能アソシエーション
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :follower#自分をフォローしている人

  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :followed#自分がフォローしてる人
  
  #DM機能アソシエーション
  has_many :user_rooms
  has_many :rooms, through: :user_rooms
  has_many :chats
  

  validates :name, uniqueness: true, length: { in: 2..20 }
  validates :introduction, length: { maximum: 50 }

  # 公開・非公開機能
  scope :release, -> {where(status: true)}
  scope :nonrelease, -> {where(status: false)}

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpeg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  #フォローをするための処理
  def follow(user)#このユーザーはコントローラーで.findしたユーザー
    relationships.create(followed_id: user.id)
    #コントローラーでレシーバをcurrent_userにしているのでカレントユーザのfollowed_idに保存しているということになる
    #Relationship.new(follower_id: current_user.id, followed_id: user.id)でもいける
    #relationships.create(followed_id: user.id)この記述で()内にfollower_id: current_user.idがないのは
    ##has_many :relationships, class_name: "Rlationship", foreign_key: "follower_id", dependent: :destroyこのアソシエーションで
    ###current_userのfollowed_idを渡さなくてももう知っているから
  end

  #フォローを外すための処理
  def unfollow(user)
    relationships.find_by(followed_id: user.id).destroy
  end

  #フォローしているかの判定をする
  def following?(user)
    followings.include?(user)
  end

  def self.search_for(content, method)
    if method == 'perfect'
      User.where('name: content')
    elsif method == 'forward'
      User.where('name LIKE ?', content + '%')
    elsif method == 'backward'
      User.where('name LIKE ?', '%' + content)
    else
      User.where('name LIKE ?', '%' + content + '%')
    end
  end

  def self.guest
    find_or_create_by!(name: 'guestuser' ,email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "guestuser"
    end
  end
end
