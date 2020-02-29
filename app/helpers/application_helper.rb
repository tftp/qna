module ApplicationHelper

  def output_link(link)
    if link.gist?
      content_tag :script,'' , src: "#{link.url}.js", class: "gist-script"
    else
      link_to link.name, link.url
    end
  end

  def output_count_votes(votable)
      content_tag :div, "#{votable.count_votes}", class: "vote-mark-#{votable.class.to_s.underscore}", id: "#{votable.id}"
  end

  def vote_positive_link(votable)
    link_to 'plus', polymorphic_path([:voting, votable], option: 'positive'),
              class: "#{current_user&.is_author?(votable) ? 'hidden' : 'vote-change-link'}",
              data: { votable_type: votable.class.to_s.underscore ,votable_id: votable.id, type: :json }, remote: true, method: :patch
  end

  def vote_negative_link(votable)
    link_to 'minus', polymorphic_path([:voting, votable], option: 'negative'),
              class: "#{current_user&.is_author?(votable) ? 'hidden' : 'vote-change-link'}",
              data: { votable_type: votable.class.to_s.underscore ,votable_id: votable.id, type: :json }, remote: true, method: :patch
  end

end
