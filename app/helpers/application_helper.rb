module ApplicationHelper

  def output_link(link)
    if link.gist?
      content_tag :script,'' , src: "#{link.url}.js", class: "gist-script"
    else
      link_to link.name, link.url
    end
  end
end
