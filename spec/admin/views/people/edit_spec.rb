require 'spec_helper'
require_relative '../../../../apps/admin/views/people/edit'

describe Admin::Views::People::Edit do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/people/edit.html.erb') }
  let(:view)      { Admin::Views::People::Edit.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #foo' do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
