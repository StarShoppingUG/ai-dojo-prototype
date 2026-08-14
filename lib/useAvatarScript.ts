"use client";

import { useEffect, useState } from "react";
import { AVATAR_SCRIPT_URL } from "@/lib/config";

const SCRIPT_ID = "ai-avatar-ui-script";

// Module-level singleton — shared across every component that calls
// useAvatarScript() or loadAvatarScript(), for the lifetime of this JS
// execution context (i.e. survives Next.js client-side navigation, reset
// only by a real page reload). This is deliberately NOT derived from
// document.getElementById(SCRIPT_ID): tag *presence* just means someone
// already started the request, not that the module finished loading and
// customElements.define() has run. Two components mounting in the same
// tick would otherwise race — whichever runs its effect second would see
// the first one's <script> tag already in the DOM and report "loaded"
// immediately, even though nothing has actually executed yet.
let scriptLoadPromise: Promise<void> | null = null;

/**
 * Creates (once) and returns a promise that resolves once the AI Avatar
 * Team's Web Component bundle has actually finished loading — not just
 * once a <script> tag exists for it. Safe to call multiple times; every
 * caller gets the same promise.
 *
 * Call this as early as possible in the app's lifecycle (e.g. once in the
 * root layout) rather than only inside components that happen to need
 * <avatar-settings>/<avatar-model>. If the first time this loads is the
 * moment a user client-side-navigates onto a page that needs it, the
 * fetch+parse+execute of the module competes visibly with an
 * already-interactive page — which is what made the settings button look
 * slow or briefly invisible specifically after navigation (vs. a hard
 * reload, where the browser has the whole document-parse window to get
 * ahead of it).
 */
export function loadAvatarScript(): Promise<void> {
  if (scriptLoadPromise) return scriptLoadPromise;

  scriptLoadPromise = new Promise((resolve, reject) => {
    if (typeof document === "undefined") {
      reject(new Error("loadAvatarScript called outside the browser"));
      return;
    }

    const existing = document.getElementById(
      SCRIPT_ID
    ) as HTMLScriptElement | null;
    if (existing) {
      // A tag exists already — from a previous call in this same session,
      // or from something outside this module creating it directly (this
      // used to happen: AvatarComponents.tsx had its own independent
      // script-creation code with the same id, which caused a real bug —
      // see HANDOFF3.md). Its "load" event may have already fired before
      // we got here, and DOM events don't replay for late listeners, so we
      // can't rely on the event alone. customElements.whenDefined()
      // resolves immediately if the module already ran, so race it against
      // the load/error listeners to cover both "still loading" and
      // "already finished" cases.
      Promise.race([
        customElements.whenDefined("avatar-model"),
        new Promise<void>((res, rej) => {
          existing.addEventListener("load", () => res(), { once: true });
          existing.addEventListener(
            "error",
            () => rej(new Error("avatar script failed to load")),
            { once: true }
          );
        }),
      ])
        .then(() => resolve())
        .catch(reject);
      return;
    }

    const script = document.createElement("script");
    script.id = SCRIPT_ID;
    script.type = "module";
    script.src = AVATAR_SCRIPT_URL;
    script.async = true;
    script.onload = () => resolve();
    script.onerror = () => {
      // Let a future call retry instead of being permanently stuck on a
      // failed load.
      scriptLoadPromise = null;
      reject(new Error("avatar script failed to load"));
    };
    document.body.appendChild(script);
  });

  return scriptLoadPromise;
}

/**
 * React hook wrapper around loadAvatarScript(). Returns whether the script
 * has actually finished loading (not just whether a tag exists for it).
 */
export function useAvatarScript(): boolean {
  const [loaded, setLoaded] = useState(false);

  useEffect(() => {
    let cancelled = false;

    loadAvatarScript()
      .then(() => {
        if (!cancelled) setLoaded(true);
      })
      .catch((error) => {
        if (!cancelled) {
          // eslint-disable-next-line no-console
          console.error("[useAvatarScript] failed to load avatar script:", error);
        }
      });

    return () => {
      cancelled = true;
    };
  }, []);

  return loaded;
}