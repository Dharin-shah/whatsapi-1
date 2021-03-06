require 'spec_helper'
require 'socket'

describe Whatsapi::Client do
	subject { 
		Whatsapi::Client.new(
			'254705866565',
			'a262eb2b404bc3f15144c6c4ae6ebc45fac98eba',
			'Sprout')
	}

	it { expect(subject.phone_number).to eql('254705866565') }
	it { expect(subject.identity).to eql('a262eb2b404bc3f15144c6c4ae6ebc45fac98eba') }
	it { expect(subject.name).to eql('Sprout') }

	describe 'Validation rules' do
		it 'Throws an error if no name is provided' do
			expect { Whatsapi::Client.new('254705866565', nil, nil) }.to raise_error(ArgumentError, 'name must be provided')
			expect { Whatsapi::Client.new('254705866565', nil, "") }.to raise_error(ArgumentError, 'name must be provided')
		end

		it 'Throws an error is no phone number is provided' do
			expect { Whatsapi::Client.new(nil, nil, "Sprout") }.to raise_error(ArgumentError, 'phone_number must be provided')
		end

		describe 'Creates a valid identifier if none is provided' do
			subject{ Whatsapi::Client.new('254705866565', nil, 'Sprout') }

			it { expect(subject.identity).to eql('a262eb2b404bc3f15144c6c4ae6ebc45fac98eba') }
		end

		describe 'The identifier is corrected if it is not valid' do
			subject{ Whatsapi::Client.new('254705866565', 'abc', 'Sprout') }

			it { expect(subject.identity).to eql('a262eb2b404bc3f15144c6c4ae6ebc45fac98eba') }
		end
	end

	describe 'Authentication' do

		describe 'Authentication status is disconnected before login is called' do
			subject{ Whatsapi::Client.new('254705866565', nil, 'Sprout') }

			it { expect(subject.login_status).to eql(Whatsapi::Constants::DISCONNECTED_STATUS) }
		end

		describe 'Conection to the WhatsApp server' do
			
			client = Whatsapi::Client.new('254705866565', nil, 'Sprout')
			client.connect
			
			it { expect(client.socket.nil?).to be false }
		end

		# describe 'Looking up the challenge data file' do
		# 	client = Whatsapi::Client.new('254705866565', nil, 'Sprout')
		# 	client.connect
		# 	client.login '1234567890'

		# 	it { expect(client.writer.nil?).to be false }
		# 	it { expect(client.challenge_data.nil?).to be false }
		# end

		describe "Logging into WhatsApp" do
			let(:client) { Whatsapi::Client.new('254705866565', nil, 'Sprout') }

			before(:each) do
				allow(Whatsapi::BinTreeReader).to receive(:reset_key!)
				allow(Whatsapi::BinTreeWriter).to receive(:reset_key!)				
				# allow(Whatsapi::BinTreeWriter).to receive(:start_stream)
			end

			context 'login' do
				it 'should reset both reader and writer' do									

					# expect(client.reader).to receive(:reset_key!)
					# expect(client.writer).to receive(:reset_key!)
					# client.login '12345'															
				end

				it 'should start the stream' do					
					# expect(client.writer).to receive(:start_stream).with(Whatsapi::Constants::WHATSAPP_SERVER, "#{Whatsapi::Constants::WHATSAPP_DEVICE}-#{Whatsapi::Constants::WHATSAPP_VER}-#{Whatsapi::Constants::PORT}")
					# client.login '12345'
				end
			end
		end
	end	
end