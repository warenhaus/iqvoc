class Concepts::AlphabeticalController < ConceptsController
  skip_before_filter :require_user
  
  def index
    authorize! :read, Concept::Base
    
    @alphas =
      ('A'..'Z').to_a +
      (0..9).to_a +
      ['[']
    
    @pref_labelings = Iqvoc::Concept.pref_labeling_class.
      concept_published.
      label_begins_with(params[:letter]).
      includes(:target). 
      order("LOWER(#{Label::Base.table_name}.value)").
      paginate(:page => params[:page], :per_page => 40)
  end

end