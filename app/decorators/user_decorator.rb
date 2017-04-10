class UserDecorator < Draper::Decorator
  delegate_all

  def gravatar
    gravatar_id = Digest::MD5.hexdigest(email)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?d=identicon"
    h.image_tag gravatar_url, alt: name, class: 'gravatar'
  end
end
