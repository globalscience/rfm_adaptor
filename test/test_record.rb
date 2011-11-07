# encoding: utf-8

require File.join(File.dirname(__FILE__), "test_helper")

class TestRecord < Test::Unit::TestCase
  #--------------------#
  # RfmAdaptor::Record::Base
  # レコードの基底クラスの検証
  context "Record" do
    setup do
      @rfm_record_class = Rfm::Record
      @record_class = RfmAdaptor::Record::Base
      @klass = Person
      
      @helper = TestRecordHelper
      @request_builder_class = RfmAdaptor::RequestBuilder::Base
      
      @class_methods = @helper.test_class_methods
      @scripts = @helper.test_scripts
      
    end
    
    #--------------------#
    # class context
    # クラスの検証
    context "class" do
      # Respond to class methods.
      #   create a record, create some requests.
      # 想定されたクラスメソッドにへの応答。
      #   レコードの生成や、リクエストの生成。
      should "responds" do
        @class_methods.each do |m, param|
          assert_respond_to(@klass, m)
        end
      end
      
      # Return Request::Base (except @klass.new).
      # リクエスト生成クラスを返す（@klass.new メソッド以外）。
      should "return RfmAdaptor::RequestBuilder::Base" do
        write_log_title
        @class_methods.each do |m, param|
          request = @klass.__send__(m, param)
          write_log.debug(request)
          if m.to_s == "new"
            assert_kind_of(@klass, request)
          else
            assert_kind_of(@request_builder_class, request)
          end
        end
      end
      
      # Return Rfm::Resultset with reuest.
      # リクエストに対して Rfm::Resultset を返す。
      should "return Rfm::Resultset" do
        write_log_title
        @class_methods.each do |m, param|
          unless m.to_s =~ /new/
            request = @klass.__send__(m, *param)
            write_log.debug(request.send)
          end
        end
      end
      
      #--------------------#
      # Treat responce.
      # レスポンスの挙動の検証
      context "treat responce" do
        setup do
          @result = @klass.where(:customer_name => "GlobalScience").find(:name => "Joe")
        end
        
        # Count.
        # レコードのカウント
        should "count" do
          write_log_title
          assert_kind_of(Numeric, @result.count)
          write_log.debug(" #=> #{@result.count}")
        end
        
        # Each.
        # 
        should "each" do
          write_log_title
          write_log.debug("#{@klass}.find.each")
          write_log.debug @result
          @result.each do |record|
            assert_kind_of(@klass, record)
          end
        end
        
        should "first" do
          write_log_title
          assert_kind_of(@klass, @result.last)
        end
      end
      
    end # context "class"

    #--------------------#
    # instance context
    # インスタンスの検証    
    context "instance" do
      setup do
        @name = "Joe"
        @customer = "GlobalScience"
        @customer_attribute = :customer_name
        conditions = {:name => @name, @customer_attribute => @customer}
        @record = @klass.find(conditions).first
        @instance_methods = @helper.test_instance_methods
      end
      
      # Field value with label written in configuraion file.
      # 設定ファイル中のラベルでのアクセスの検証。
      should "respond attributes with field label" do
        assert_equal(@name, @record.name)
        assert_equal(@customer, @record.__send__(@customer_attribute))
      end
      
      # Update attribute with various methods.
      # フィールドの値の更新をいろいろなメソッドを使って検証。
      should "update attribute" do
        assert_nothing_raised do
          @record.update_attribute(:name, "George")
          write_log.debug("Change name '#{@name}' to '#{@record.name}'.")
          
          @record[:name] = "John"
          write_log.debug("Change name to '#{@record.name}'.")
          
          @record.name = "Jane"
          write_log.debug("Change name to '#{@record.name}'.")
          
          @record.update_attributes({:name => @name})
          write_log.debug("Change name to '#{@record.name}'.")
        end
      end
    end
    
=begin
    should "build script request" do
      @scripts.each do |sc|
        assert_nothing_raised do
          @klass.script(sc[0], sc[1])
        end
      end
    end
    
    context "instance method" do
      should "respond to `update_attributes'" do
        assert_respond_to(@record, :update_attributes)
        assert(boolean?(@record.update_attributes(:name => @name)))
      end
      
      should "respond to `save'" do
        assert_respond_to(@record, :save)
        assert(boolean?(@record.save))
      end
      
      should "respond to `save!'" do
        assert_respond_to(@record, :save!)
        assert(boolean?(@record.save!))
      end
      
      should "respond to `destroy'" do
        assert_respond_to(@record, :destroy)
        assert(boolean?(@record.destroy))
      end
    end
    
    should "respond to attribute as method" do
      assert_nothing_raised do
        @record.name
      end
    end
=end
  end
end
