require 'spec_helper'

describe Rikuesuto::Request do
  subject(:request) { Rikuesuto::Request.new(:get, id:123) }
  it "acts as params hash" do
    expect(request[:id]).to eq 123
  end
  it "[]=" do
    request[:name] = "test"
    expect(request[:name]).to eq "test"
    request.body = "payload"
    expect {request[:name] = "test"}.to raise_error(RuntimeError)
  end

  it "authorization" do
    request.authorization = {password: "secret"}
    expect(request.authorization[:password]).to eq "secret"
  end

  it "execution" do
    request.execution = {run_at: Time.now.to_f}
    expect(request.execution[:run_at]).to be <= Time.now.to_f
  end

  it "pagination" do
    request.pagination = {page: 1}
    expect(request.pagination[:page]).to eq 1
  end

  it "to_hash" do
    expect(request.to_hash[:id]).to eq 123
  end

  it "to_json" do
    expect(request.to_json).to include(%Q{"id":123})
  end

  #it "to_http" do
    #expect(request.to_http).to include(%Q{"id":123})
  #end

end
