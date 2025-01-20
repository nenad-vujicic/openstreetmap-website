FactoryBot.define do
  factory :note_comment do
    sequence(:body) { |n| "This is note comment #{n}" }
    visible { true }
    event { "opened" }
    note

    after(:create) do |note_comment|
      note_comment.note.author = note_comment.author
      note_comment.note.user_id = note_comment.author_id
      note_comment.note.user_ip = note_comment.author_ip
    end
  end
end
