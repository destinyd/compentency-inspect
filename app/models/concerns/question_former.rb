module QuestionFormer
  extend ActiveSupport::Concern

  included do

    former "QuestionBank::Question" do
      field :id, ->(instance) {instance.id.to_s}
      field :kind
      field :content
      field :point_ids, ->(instance){
        instance.point_ids.map(&:to_s)
      }

      logic :choices, ->(instance, user) {
        instance.sorted_choices(user)
      }

      logic :answer, ->(instance, user) {
        tpr = user.inspect_test_paper_result
        return nil if tpr.blank?

        qr = QuestionBank::QuestionRecord.where(test_paper_result_id: tpr.id, question_id: instance.id).first
        return nil if qr.blank?

        if instance.kind.to_sym == :file_upload
          return {
            file_entity_id: qr.answer,
            download_url: FilePartUpload::FileEntity.find(qr.answer).download_url
          }
        end
        return qr.answer
      }

      logic :admin_answer, ->(instance) {
        instance.answer
      }

      logic :point_names, ->(instance){
        instance.points.map(&:name)
      }


      url :admin_edit_url, ->(instance){
        edit_admin_question_path(instance)
      }

    end

  end
end
