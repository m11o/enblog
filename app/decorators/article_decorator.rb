module ArticleDecorator
  def meta_tags
    {
      title: "Love Beautiful Code | #{title}",
      description: description.presence || body.to_plain_text.truncate(100),
      keywords: tags.pluck(:name).join(','),
      canonical: front_content_path
    }
  end
end
