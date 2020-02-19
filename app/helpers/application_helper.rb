module ApplicationHelper

  def check_for_gist_link(link)
    if link.url.include?('gist.github.com')
      content_tag :script,'' , src: "#{link.url}.js", class: "gist-script"
    else
      link_to link.name, link.url
    end
  end

end
