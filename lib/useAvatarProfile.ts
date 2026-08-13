"use client";

import { useEffect, useState } from "react";
import { useAvatarScript } from "@/lib/useAvatarScript";

const PROFILE_EVENT = "avatar:update-profile";
// Fired if genuinely nothing has arrived after INITIAL_WAIT_MS — see caveat
// below. NEVER avatar:select-avatar: that's a write (forces the widget onto
// a given avatarId) and is the exact event whose fallback-on-bad-id
// behavior caused Bug 2 (see HANDOFF-avatar-persistence-bug.md). This hook
// must never dispatch it again.
const REQUEST_EVENT = "avatar:request-current-profile";
const INITIAL_WAIT_MS = 2500;
const TIMEOUT_MS = 6000;

export type AvatarProfile = {
  name: string | null;
  persona: string | null;
  thumbnail: string | null;
  raw: unknown;
};

export type ProfileStatus = "loading" | "ok" | "timeout";

const NAME_KEYS = ["name", "displayName", "avatarName", "label"];
const PERSONA_KEYS = ["persona", "description", "bio", "tagline"];
const THUMBNAIL_KEYS = [
  "thumbnail",
  "thumbnailUrl",
  "image",
  "imageUrl",
  "preview",
  "previewUrl",
  "avatarThumbnail",
];

function firstStringField(
  obj: Record<string, unknown>,
  keys: string[]
): string | null {
  for (const key of keys) {
    const val = obj[key];
    if (typeof val === "string" && val.trim().length > 0) return val;
  }
  return null;
}

export function useAvatarProfile(
  instance: string
): { profile: AvatarProfile | null; status: ProfileStatus } {
  const scriptLoaded = useAvatarScript();
  const [profile, setProfile] = useState<AvatarProfile | null>(null);
  const [status, setStatus] = useState<ProfileStatus>("loading");

  useEffect(() => {
    if (!scriptLoaded) return;

    let gotProfile = false;

    function handleProfile(e: Event) {
      const detail = (e as CustomEvent).detail;
      if (typeof detail !== "object" || detail === null) return;
      const obj = detail as Record<string, unknown>;

      // Only filter by instance if the payload actually has one — see
      // caveat above.
      if ("instance" in obj && obj.instance !== instance) return;

      // eslint-disable-next-line no-console
      console.log(
        `[useAvatarProfile:${instance}] raw "${PROFILE_EVENT}" detail:`,
        detail
      );

      gotProfile = true;
      setProfile({
        name: firstStringField(obj, NAME_KEYS),
        persona: firstStringField(obj, PERSONA_KEYS),
        thumbnail: firstStringField(obj, THUMBNAIL_KEYS),
        raw: detail,
      });
      setStatus("ok");
    }

    window.addEventListener(PROFILE_EVENT, handleProfile as EventListener);

    // Passive at first: give <avatar-settings> a chance to broadcast on its
    // own once it's resolved its persisted state. Only ask explicitly if
    // nothing shows up — and asking is a read request, not a selection.
    const requestTimer = setTimeout(() => {
      if (gotProfile) return;
      const requestDetail = { instance };
      // eslint-disable-next-line no-console
      console.log(
        `[useAvatarProfile:${instance}] no passive "${PROFILE_EVENT}" yet, dispatching read-only "${REQUEST_EVENT}":`,
        requestDetail
      );
      window.dispatchEvent(
        new CustomEvent(REQUEST_EVENT, { detail: requestDetail })
      );
    }, INITIAL_WAIT_MS);

    const timeout = setTimeout(() => {
      setStatus((cur) => (cur === "loading" ? "timeout" : cur));
    }, TIMEOUT_MS);

    return () => {
      window.removeEventListener(PROFILE_EVENT, handleProfile as EventListener);
      clearTimeout(requestTimer);
      clearTimeout(timeout);
    };
  }, [scriptLoaded, instance]);

  return { profile, status };
}