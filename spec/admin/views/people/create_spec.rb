require 'spec_helper'
require_relative '../../../../apps/admin/views/people/create'

describe Admin::Views::People::Create do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/people/create.html.erb') }
  let(:view)      { Admin::Views::People::Create.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #foo' do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
