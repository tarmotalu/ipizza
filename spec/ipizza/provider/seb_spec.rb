# -*- encoding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Ipizza::Provider::Seb do
  describe '#payment_request' do
  
    before(:each) do
      @payment = Ipizza::Payment.new(:stamp => 1, :amount => '123.34', :refnum => 1, :message => 'Payment message', :currency => 'EUR')
    end
    
    it 'should sign the request' do
      req = Ipizza::Provider::Seb.new.payment_request(@payment)
      req.sign_params['VK_MAC'].should == 'b+BDCAzFseg32yZpFwUupwZYtJbzUqswSUo46+0WV0KO7iGrNHfHHUzvdo8TOWxHh6kobM1//t0GmRxs23zOCJH9+3mZXFDxFfinINvKLIDy4EDIrN6oxWP5Vlckzh7l9CeNy+QoeeSxBwkYlYstpdVu/7sgkNHDbf7s5twCXXzd+KIEabOovOaGkPmkQ43+nq159I4XHRHwlGrddi3YmOQ+K54Tn06tnmh/XeAyE937NiIEdcMikKPW+J0iJAMDYR220PIySeHuq3tMoagkHGe2hVkorarZ4wJurGn/pi+s3w9ptpSKkvws6n/01I217ZgdionHK/IkLgB7RNa8Rg=='
    end
  end

  describe '#payment_response' do
    before(:each) do
      @params = {
        'VK_T_NO' => '1143', 'VK_REF' => '201107010000048', 'VK_SND_NAME' => 'TÕÄGER Leõpäöld¸´¨¦', 'VK_REC_ID' => 'testvpos',
        'appname' => 'UN3MIN', 'keel' => 'EST', 'VK_T_DATE' => '01.07.2011', 'VK_SND_ACC' => '10010046155012', 'VK_STAMP' => '20110701000004',
        'VK_CHARSET' => 'UTF-8', 'VK_RETURN' => 'https://store.kraftal.com/return/seb', 'VK_LANG' => '', 'VK_REC_NAME' => 'ALLAS ALLAR',
        'VK_AMOUNT' => '.17', 'VK_SERVICE' => '1101', 'VK_AUTO' => 'N', 'VK_MSG' => 'Edicy invoice #20110701000004', 'act' => 'UPOSTEST2',
        'VK_SND_ID' => 'EYP', 'VK_VERSION' => '008', 'VK_REC_ACC' => '10002050618003', 'VK_CURR' => 'EUR',
        'VK_MAC' => 'fj7moIwqMbvhmftFs5/5muOD1Dj5sRIlTUUcXGbzNKGFCrRz/N2ZpprFlO+8el7BNnGAoqCc2b4V2BrJ5XRsyYtLy1Gi4W8eSqwxbjBefDo21PFXpTmXYYJVy98fIWmWhOIBPMnEq6BlVf100GlV1C3OL+2mBU/ZjtPQG+B7OHo='
      }
    end
    
    it 'should parse and verify the payment response from bank' do
      puts Ipizza::Provider::Seb.snd_id.inspect
      Ipizza::Provider::Seb.new.payment_response(@params).should be_valid
    end
  end

  describe '#authentication_request' do
    before(:each) do
      Time.stub(:now).and_return(Time.parse('Mar 30 1981'))
      Date.stub(:today).and_return(Date.parse('Mar 30 1981'))
    end
    
    it 'should sign the request' do
      req = Ipizza::Provider::Seb.new.authentication_request
      req.sign_params['VK_MAC'].should == 'x5cw9hhsiAsoh6y/UWowo8gUSkEjLhvI7+XJAXsGmdjDAxrsh//TAyXeaG05p8qOVjMeNce22tvkLU2XAml3kCaldQTS1FhvXlm8Z2Q58zzquvp2nBkHeI2R1XW6bxBGQAxHnPCop9c7WFp1w1b981Pfg0CMqrjfTivJKYVVTSgxGATPw/9AvZCCsN8bM8nXUjhcHZj+ar+QiQBXx8LOeXr+jXMVyDgSe47Mqa0nGnKFAksmBqVTOItHHgEy12EID/bW5iwFi6hykgmHEW74idHdjLnikJA+Qu+wU8QONk51f1BZwMgzvxZYDGPFvtbr05gcH6zijko1rDWEg5i/jA=='
    end
  end

  describe '#authentication_response' do
    before(:each) do
      @params = {
        'VK_TIME' => '00:56:37', 'VK_USER' => '', 'VK_INFO' => 'NIMI:tõõger , LeõpäöldžŽšŠ;ISIK:35511280268',
        'VK_DATE' => '24.10.2010', 'VK_CHARSET' => 'UTF-8', 'VK_RETURN' => 'http://rkas-aktide-is.local/ipizza/auth',
        'VK_LANG' => 'EST', 'VK_SERVICE'=>'3002', 'VK_RID' => '', 'VK_SND_ID' => 'EYP', 'VK_VERSION' => '008',
        'VK_MAC' => 'BeYfkTTj9HNCoMSVbBHSYujFpdcPfo3Ee56ZwaHzYwLj3/QMsb3b5cA7Z1GjeW2VLIoWVtOZmjWN9N74NtH7mu0Nv3RUYep6DJcsZvejs9uklpCLFS1bzInGlQKh3Q04Vttss6dLxgoRJu7lT3hvPKUPHtBZ2RZMHByLuwqNqC4='
      }
    end
    
    it 'should parse and verify the authentication response from bank' do
      Ipizza::Provider::Seb.new.authentication_response(@params).should be_valid
    end
  end
end