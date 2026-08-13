import type { DetailedHTMLProps, HTMLAttributes } from "react";

type AvatarElementProps = DetailedHTMLProps<
  HTMLAttributes<HTMLElement>,
  HTMLElement
> & {
  backend?: string;
  "app-id"?: string;
  "user-id"?: string;
  instance?: string;
  "avatar-scale"?: string;
  "avatar-vertical-offset"?: string;
};

declare global {
  namespace JSX {
    interface IntrinsicElements {
      "avatar-model": AvatarElementProps;
      "avatar-status": AvatarElementProps;
      "avatar-captions": AvatarElementProps;
      "avatar-settings": AvatarElementProps;
      "avatar-inputs": AvatarElementProps;
    }
  }
}

export {};
