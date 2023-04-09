class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_one_attached :profile_image

  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :follower#自分をフォローしている人

  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :followed#自分がフォローしてる人

  validates :name, uniqueness: true, length: { in: 2..20 }
  validates :introduction, length: { maximum: 50 }

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

end
