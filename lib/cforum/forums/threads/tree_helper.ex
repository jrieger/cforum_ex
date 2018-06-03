defmodule Cforum.Forums.Threads.TreeHelper do
  alias Cforum.Forums.Thread
  alias Cforum.Forums.Message
  alias Cforum.Helpers

  def sort_threads(threads, direction, thread_modifier),
    do: Enum.map(threads, &sort_thread(direction, thread_modifier, &1))

  def sort_thread(direction, modifier, thread, message \\ nil)
  def sort_thread(direction, modifier, thread, nil), do: gen_thread_tree(modifier, thread, direction)

  def gen_thread_tree(modifier, thread, direction \\ "ascending") do
    sorted_messages =
      Enum.sort(thread.messages, fn a, b ->
        cond do
          a.parent_id == b.parent_id && direction == "ascending" ->
            v = Timex.compare(a.created_at, b.created_at)
            v == -1 || v == 0

          a.parent_id == b.parent_id && direction == "descending" ->
            v = Timex.compare(a.created_at, b.created_at)
            v == 1 || v == 0

          true ->
            Helpers.to_int(a.parent_id) <= Helpers.to_int(b.parent_id)
        end
      end)

    thread =
      if modifier != nil do
        %Thread{thread | sorted_messages: sorted_messages}
        |> modifier.()
      else
        %Thread{thread | sorted_messages: sorted_messages}
      end

    tree =
      thread.sorted_messages
      |> Enum.reverse()
      |> Enum.reduce(%{}, fn msg, map ->
        msg = %Message{msg | messages: Map.get(map, msg.message_id, [])}
        Map.update(map, msg.parent_id, [msg], fn msgs -> [msg | msgs] end)
      end)
      |> Map.get(nil)
      |> hd

    %Thread{
      thread
      | sorted_messages: sorted_messages,
        message: tree,
        tree: tree,
        accepted: Enum.filter(sorted_messages, &(&1.flags["accepted"] == "yes"))
    }
  end
end
