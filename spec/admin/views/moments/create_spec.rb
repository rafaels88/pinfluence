require 'spec_helper'
require_relative '../../../../apps/admin/views/moments/create'

describe Admin::Views::Moments::Create do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/moments/create.html.erb') }
  let(:view)      { Admin::Views::Moments::Create.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #foo' do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
