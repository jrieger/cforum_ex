import { parseMessageUrl } from "../modules/helpers";

export const openThreadHelper = (requestParams, form) => {
  const parsedUrl = parseMessageUrl(form.action);
  requestParams.method = "POST";
  requestParams.headers = { "Content-Type": "application/json; charset=utf-8" };
  requestParams.body = JSON.stringify({ slug: parsedUrl.slug });
  return { url: "/api/v1/threads/close" };
};

export const closeThreadHelper = (requestParams, form) => {
  const parsedUrl = parseMessageUrl(form.action);
  requestParams.method = "POST";
  requestParams.headers = { "Content-Type": "application/json; charset=utf-8" };
  requestParams.body = JSON.stringify({ slug: parsedUrl.slug });
  return { url: "/api/v1/threads/open" };
};

export const hideThreadHelper = (requestParams, form) => {
  const parsedUrl = parseMessageUrl(form.action);
  requestParams.method = "POST";
  requestParams.headers = { "Content-Type": "application/json; charset=utf-8" };
  requestParams.body = JSON.stringify({ slug: parsedUrl.slug });
  return {
    url: "/api/v1/threads/hide",
    afterAction: response => {
      response.json().then(json => {
        // TODO error handling
        if (json.status == "ok") {
          form.closest(".cf-thread").remove();
        }
      });
    }
  };
};

export const unhideThreadHelper = (requestParams, form) => {
  const parsedUrl = parseMessageUrl(form.action);
  requestParams.method = "POST";
  requestParams.headers = { "Content-Type": "application/json; charset=utf-8" };
  requestParams.body = JSON.stringify({ slug: parsedUrl.slug });
  return {
    url: "/api/v1/threads/unhide",
    afterAction: response => {
      response.json().then(json => {
        // TODO error handling
        if (json.status == "ok") {
          form.closest(".cf-thread").remove();
        }
      });
    }
  };
};

export const markReadHelper = (requestParams, form) => {
  const parsedUrl = parseMessageUrl(form.action);
  requestParams.method = "POST";
  requestParams.headers = { "Content-Type": "application/json; charset=utf-8" };
  requestParams.body = JSON.stringify({ slug: parsedUrl.slug });
  return { url: "/api/v1/messages/mark-read" };
};

export const markInterestingHelper = (requestParams, form) => {
  const parsedUrl = parseMessageUrl(form.action);
  requestParams.method = "POST";
  requestParams.headers = { "Content-Type": "application/json; charset=utf-8" };
  requestParams.body = JSON.stringify({
    slug: parsedUrl.slug,
    message_id: parsedUrl.messageId,
    forum: parsedUrl.forum
  });
  return { url: "/api/v1/messages/interesting" };
};
export const markBoringHelper = (requestParams, form) => {
  const parsedUrl = parseMessageUrl(form.action);
  requestParams.method = "POST";
  requestParams.headers = { "Content-Type": "application/json; charset=utf-8" };
  requestParams.body = JSON.stringify({
    slug: parsedUrl.slug,
    message_id: parsedUrl.messageId,
    forum: parsedUrl.forum
  });
  return { url: "/api/v1/messages/boring" };
};

export const subscribeMessageHelper = (requestParams, form) => {
  const parsedUrl = parseMessageUrl(form.action);
  requestParams.method = "POST";
  requestParams.headers = { "Content-Type": "application/json; charset=utf-8" };
  requestParams.body = JSON.stringify({
    slug: parsedUrl.slug,
    message_id: parsedUrl.messageId,
    forum: parsedUrl.forum
  });
  return { url: "/api/v1/messages/subscribe" };
};
export const unsubscribeMessageHelper = (requestParams, form) => {
  const parsedUrl = parseMessageUrl(form.action);
  requestParams.method = "POST";
  requestParams.headers = { "Content-Type": "application/json; charset=utf-8" };
  requestParams.body = JSON.stringify({
    slug: parsedUrl.slug,
    message_id: parsedUrl.messageId,
    forum: parsedUrl.forum
  });
  return { url: "/api/v1/messages/unsubscribe" };
};