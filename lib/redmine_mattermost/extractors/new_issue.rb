module RedmineMattermost
  module Extractors
    class NewIssue < Base
      MESSAGE = "[%{project_link}] %{author} created %{object_link}%{mentions}"

      def from_context(context)
        issue = context.fetch(:issue)
        return if issue.is_private?
        return unless channel = determine_channel(issue.project)
        return unless url = determine_url(issue.project)

        args = {
          project_link: link(issue.project, event_url(issue.project)),
          author: h(issue.author),
          object_link: link(issue, event_url(issue)),
          mentions: extract_mentions(issue.description)
        }

        msg = MessageBuilder.new(MESSAGE % args)
        msg.channel(channel)
        attachment = msg.attachment
        attachment.text(to_markdown issue.description) if issue.description
        attachment.field(t("field_status"), h(issue.status), true)
        attachment.field(t("field_priority"), h(issue.priority), true)
        attachment.field(t("field_assigned_to"), h(issue.assigned_to), true)

        if show_watchers? && !issue.watcher_users.empty?
          attachment.field(
            t("field_watcher"), h(issue.watcher_users.join(", ")), true
          )
        end

        { url: url, message: msg.to_hash }
      end
    end
  end
end