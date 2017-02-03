require 'faraday'
require 'faraday-manual-cache'
require 'active_support'

# Mock store that implements the most minimal requirements possible: A `#fetch`
# method and `#write` method.
class MockStore
  def fetch(*args) end

  def write(*args) end
end

RSpec.shared_examples_for 'accesses cache' do
  it { expect(store).to receive(:fetch) }
  it { expect(store).to receive(:write) }
end

RSpec.shared_examples_for 'does not access cache' do
  it { expect(store).not_to receive(:fetch) }
  it { expect(store).not_to receive(:write) }
end

RSpec.describe Faraday::ManualCache do
  describe 'HTTP verbs' do
    subject do
      Faraday.new(url: 'http://www.example.com') do |faraday|
        faraday.use :manual_cache, **options
        faraday.adapter :test, stubs
      end
    end

    let(:options) { {} }
    let(:store) { MockStore.new }
    let(:stubs) do
      Faraday::Adapter::Test::Stubs.new do |stub|
        stub.get('/') { |_| [200, {}, ''] }
        stub.head('/') { |_| [200, {}, ''] }
        stub.post('/') { |_| [200, {}, ''] }
        stub.put('/') { |_| [200, {}, ''] }
      end
    end

    before do
      allow(ActiveSupport::Cache).to receive(:lookup_store).and_return(store)
      allow(store).to receive(:fetch)
      allow(store).to receive(:write)
    end

    context 'default configuration' do
      context 'GET' do
        after { expect { subject.get('/') }.not_to output.to_stdout }
        it_behaves_like 'accesses cache'
      end

      context 'HEAD' do
        after { subject.head('/') }
        it_behaves_like 'accesses cache'
      end

      context 'POST' do
        after { subject.post('/') }
        it_behaves_like 'does not access cache'
      end

      context 'PUT' do
        after { subject.put('/') }
        it_behaves_like 'does not access cache'
      end
    end

    context 'conditional configuration' do
      let(:options) { { conditions: ->(_) { true } } }

      after { subject.get('/') }

      context 'GET' do
        it_behaves_like 'accesses cache'
      end

      context 'HEAD' do
        it_behaves_like 'accesses cache'
      end

      context 'POST' do
        it_behaves_like 'accesses cache'
      end

      context 'PUT' do
        it_behaves_like 'accesses cache'
      end
    end

    context 'expiry configuration' do
      let(:options) { { expires_in: 60 } }

      it 'should pass the expiry to the store' do
        expect(store).to receive('write').with(
          anything,
          anything,
          hash_including(expires_in: 60)
        )

        subject.get('/')
      end
    end

    context 'logger configuration' do
      let(:options) { { logger: Logger.new($stdout) } }

      it 'should output to STDOUT' do
        expect { subject.get('/') }.to output.to_stdout
      end
    end

    context 'store configuration' do
      let(:new_store) { MockStore.new }
      let(:options) { { store: new_store } }

      it 'should use specified store, if provided' do
        expect(new_store).to receive(:fetch)
        expect(new_store).to receive(:write)
        subject.get('/')
      end
    end
  end
end
