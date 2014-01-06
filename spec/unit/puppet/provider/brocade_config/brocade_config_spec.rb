#! /usr/bin/env ruby

require 'spec_helper'
require 'yaml'
require 'puppet/provider/brocade_fos'
require 'puppet/util/network_device/brocade_fos/device'
require 'puppet/util/network_device/base_fos'
require 'rspec/mocks'
require 'puppet/provider/brocade_responses'
require 'puppet/provider/brocade_messages'

describe Puppet::Type.type(:brocade_config).provider(:brocade_config) do

  context "when brocade_config provider is created " do
    it "should have create method defined for brocade_config" do
      described_class.instance_method(:create).should_not == nil

    end

    it "should have destroy method defined for brocade_config" do
      described_class.instance_method(:destroy).should_not == nil
    end

    it "should have exists? method defined for brocade_config" do
      described_class.instance_method(:exists?).should_not == nil

    end
  end

  context "when brocade config is created and/or its state is changed" do
  it "should warn if brocade config name is already exist and process the brocade config state"
  
  it "should create brocade config if brocade config name is not present and process the brocade config state"
  
  it "should raise error if response contains 'invalid' while creating brocade config"
   
  it "should raise error if response contains 'name too long' while creating brocade config"
   
   it "should enable the brocade config state when brocade config state value is enabled in resource"
   
   it "should raise error if response contains 'not found' while enabling the brocade config state"
   
   it "should disable the brocade config state when brocade config state value is disabled in resource"
   
   it "should warn if no effective brocade config found while disabling the brocade config state"
   end
   
   context "when brocade config is deleted" do
   it "should delete the already existing brocade config"
   
   it "should warn if brocade config name does not exist"
   
   it "should raise error if response contains 'should not be deleted'"
   
   end
   
   context "when brocade config existence is validated" do
   it "should return true when the brocade config existence is required"
   
   it "should return false when the brocade config existence is not required"
   
   end
   
end

