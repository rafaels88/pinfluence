require 'spec_helper'
require_relative '../../../../apps/admin/views/people/update'

describe Admin::Views::People::Update do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/people/update.html.erb') }
  let(:view)      { Admin::Views::People::Update.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #foo' do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
