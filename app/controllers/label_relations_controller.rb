class LabelRelationsController < ApplicationController
  def create
    @domain_label = Label.new_version(params[:versioned_label_id]).first.blank? ? Label.initial_version(params[:versioned_label_id]).first : Label.new_version(params[:versioned_label_id]).first
    @range_label = Label.find(params[:id])
    @versioned_range_label = Label.new_version(@range_label.origin).first
  end

  def destroy
    label_relation = LabelRelation.find(params[:id])
    versioned_range_label = Label.new_version(label_relation.range.origin).first
    if versioned_range_label.present?
      versioned_range_label_relation = label_relation.class.name.constantize.find(:first, :conditions => ["domain_id = :domain_id AND range_id = :range_id", {:domain_id => label_relation.domain_id, :range_id => versioned_range_label.id}])
      ActiveRecord::Base.transaction do
      if label_relation.destroy && versioned_range_label_relation.destroy
        head :ok
      else
        head :internal_server_error
      end
      end
    else
      if label_relation.destroy
        head :ok
      else
        head :internal_server_error
      end
    end
  rescue
    head :internal_server_error
  end
end