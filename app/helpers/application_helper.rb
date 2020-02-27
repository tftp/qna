module ApplicationHelper

  def output_link(link)
    if link.gist?
      content_tag :script,'' , src: "#{link.url}.js", class: "gist-script"
    else
      link_to link.name, link.url
    end
  end

  def output_count_votes(votable)
    if votable.class.eql? Question
      content_tag :div, "#{votable.count_votes}", class: "vote-mark-question", data: { question_id: votable.id }
    else
      content_tag :div, "#{votable.count_votes}", class: "vote-mark-answer", data: { answer_id: votable.id }
    end
  end

  def vote_positive_link(votable)
    if votable.class.eql? Question
      link_to 'plus', polymorphic_path([:vote, votable], option: 'positive'),
                class: "#{current_user&.is_author?(votable) ? 'hidden' : 'vote-pisitive-link'}",
                data: { question_id: votable.id, type: :json }, remote: true, method: :patch
    else
      link_to 'plus', polymorphic_path([:vote, votable], option: 'positive'),
                class: "#{current_user&.is_author?(votable) ? 'hidden' : 'vote-pisitive-link'}",
                data: { answer_id: votable.id, type: :json }, remote: true, method: :patch
    end
  end

  def vote_negative_link(votable)
    if votable.class.eql? Question
      link_to 'minus', polymorphic_path([:vote, votable], option: 'negative'),
                class: "#{current_user&.is_author?(votable) ? 'hidden' : 'vote-negative-link'}",
                data: { question_id: votable.id, type: :json }, remote: true, method: :patch
    else
      link_to 'minus', polymorphic_path([:vote, votable], option: 'negative'),
                class: "#{current_user&.is_author?(votable) ? 'hidden' : 'vote-negative-link'}",
                data: { answer_id: votable.id, type: :json }, remote: true, method: :patch
    end
  end

end
