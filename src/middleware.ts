import { withAuth } from "next-auth/middleware";
import { NextResponse } from "next/server";

export default withAuth(
  function middleware(req) {
    const token = req.nextauth.token;
    const pathname = req.nextUrl.pathname;

    // Redirect based on role
    if (pathname.startsWith("/nutricionista") && token?.rol !== "NUTRICIONISTA") {
      return NextResponse.redirect(new URL("/paciente", req.url));
    }

    if (pathname.startsWith("/paciente") && token?.rol !== "PACIENTE") {
      return NextResponse.redirect(new URL("/nutricionista", req.url));
    }

    return NextResponse.next();
  },
  {
    callbacks: {
      authorized: ({ token }) => !!token,
    },
  }
);

export const config = {
  matcher: ["/nutricionista/:path*", "/paciente/:path*"],
};
