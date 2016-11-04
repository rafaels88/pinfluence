require 'spec_helper'
require_relative '../../../../apps/admin/views/moments/destroy'

describe Admin::Views::Moments::Destroy do
  let(:exposures) { Hash[foo: 'bar'] }
  let(:template)  { Hanami::View::Template.new('apps/admin/templates/moments/destroy.html.erb') }
  let(:view)      { Admin::Views::Moments::Destroy.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #foo' do
    view.foo.must_equal exposures.fetch(:foo)
  end
end
