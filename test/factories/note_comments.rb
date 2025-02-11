FactoryBot.define do
  factory :note_comment do
    sequence(:body) { |n| "This is note comment #{n}" }
    visible { true }
    event { "opened" }
    note

    after(:create) do |note_comment|
      note_comment.note.update(:description => note_comment.body, :user_id => note_comment.author_id, :user_ip => note_comment.author_ip) if note_comment.note.description.blank?
    end
  end
end
