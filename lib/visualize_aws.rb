require 'trollop'
require_relative 'ec2/security_groups'
require_relative 'provider/json'
require_relative 'provider/ec2'
require_relative 'graph'
require_relative 'color_picker'

class VisualizeAws
  def initialize(options={})
    @options = options
    provider = options[:source_file].nil? ? Ec2Provider.new(options) : JsonProvider.new(options)
    @security_groups = SecurityGroups.new(provider)
  end

  def unleash(output_file)
    g = build
    render(g, output_file)
  end

  def build
    g = Graph.new
    @security_groups.each_with_index { |group, index|
      picker = ColorPicker.new(@options[:color])
      if group.name.match(@options[:group_name])
       g.add_node(group.name)
       group.traffic.each { |traffic|
        if traffic.ingress
          g.add_edge(traffic.from, traffic.to, :color => picker.color(index, traffic.ingress), :style => 'bold', :label => traffic.port_range)
        elsif @options[:egress] 
          g.add_edge(traffic.to, traffic.from, :color => picker.color(index, traffic.ingress), :style => 'bold', :label => traffic.port_range)
        end
      }
      end
    }
    g
  end

  def render(g, output_file)
    extension = File.extname(output_file)
    g.output(extension[1..-1].to_sym => output_file, :use => 'dot')
  end
end

if __FILE__ == $0
  opts = Trollop::options do
    opt :access_key, 'AWS access key', :type => :string
    opt :secret_key, 'AWS secret key', :type => :string
    opt :region, 'AWS region to query', :default => 'us-east-1', :type => :string
    opt :source_file, 'JSON source file containing security groups', :type => :string
    opt :filename, 'Output file name', :type => :string, :default => 'aws-security-viz.png'
    opt :color, 'Colored node edges', :default => false
    opt :group_name, 'Group name starts with', :type => :string, :default => ''
    opt :egress, 'Show egress rules', :default => false
  end
  if opts[:source_file].nil?
    Trollop::die :access_key, 'is required' if opts[:access_key].nil?
    Trollop::die :secret_key, 'is required' if opts[:secret_key].nil?
  end
  VisualizeAws.new(opts).unleash(opts[:filename])
end
