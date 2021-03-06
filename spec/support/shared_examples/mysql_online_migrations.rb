shared_examples_for "a method that adds LOCK=NONE when needed" do
  before(:each) do
    stub_execute
  end

  it "adds LOCK=NONE at the end of the query" do
    queries.each do |arguments, output|
      Array.wrap(output).each { |out| should_receive(:execute).with(add_lock_none(out, comma_before_lock_none)) }
      @adapter.public_send(method_name, *arguments)
    end
  end

  context "with AR global setting set to false" do
    before(:each) { set_ar_setting(false) }

    it "doesn't add lock none" do
      queries.each do |arguments, output|
        Array.wrap(output).each { |out| should_receive(:execute).with(out) }
        @adapter.public_send(method_name, *arguments)
      end
    end
  end

  context "with lock: true option" do
    it "doesn't add lock none" do
      queries.each do |arguments, output|
        Array.wrap(output).each { |out| should_receive(:execute).with(out) }
        arguments[-1] = arguments.last.merge(lock: true)
        @adapter.public_send(method_name, *arguments)
      end
    end
  end
end

shared_examples_for "a request with LOCK=NONE that doesn't crash in MySQL" do
  it "succeeds without exception" do
    queries.each do |_, output|
      Array.wrap(output).each do |out|
        @adapter.execute(add_lock_none(out, comma_before_lock_none))
        rebuild_table
      end
    end
  end
end