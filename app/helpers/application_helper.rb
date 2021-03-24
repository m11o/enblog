module ApplicationHelper
  def front_default_meta_tags
    {
      title: 'Love Beautiful Code',
      reverse: true,
      separator: '|',
      description: 'top and contents list page',
      keywords: 'ruby,blog,programming,python,javascript',
      canonical: '/',
      icon: [{ href: '/favicon.ico' }]
    }
  end
end
