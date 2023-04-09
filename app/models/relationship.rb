class Relationship < ApplicationRecord

  belongs_to :follower, class_name: "User"#自分がフォローしたユーザー
  belongs_to :followed, class_name: "User"#自分をフォローしてくれたユーザー

end
