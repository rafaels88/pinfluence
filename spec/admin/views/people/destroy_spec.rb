require 'spec_helper'
require_relative '../../../../apps/admin/views/people/destroy'

describe Admin::Views::People::Destroy do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/people/destroy.html.erb') }
  let(:view)      { Admin::Views::People::Destroy.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #foo' do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
