namespace '/ceph_mon_nodes' do
  get do
    @ceph_mon_nodes = CephMonNode.all
    return_resource object: @ceph_mon_nodes
  end

  post do
    @ceph_mon_node = CephMonNode.create!(params[:ceph_mon_node])
    return_resource object: @ceph_mon_node
  end

  before %r{\A/(?<id>\d+)/?.*} do
    @ceph_mon_node = CephMonNode.find(params[:id])
  end

  namespace '/:id' do
    delete do
      return_resource object: @ceph_mon_node.delete
    end

    patch do
      @ceph_mon_node.assign_attributes(params[:ceph_mon_node]).save!
      return_resource object: @ceph_mon_node
    end

    get do
      return_resource object: @ceph_mon_node
    end
  end
end
