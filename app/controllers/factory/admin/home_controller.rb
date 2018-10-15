class Factory::Admin::HomeController < Factory::Admin::BaseController

  def index
    if current_receiver
      @notifications = current_receiver.received_notifications.order(read_at: :asc)
    else
      @notifications = Notification.none
    end
  end


end
