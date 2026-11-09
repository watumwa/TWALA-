import type {Metadata} from "next";
import "./globals.css";
export const metadata:Metadata={title:"TWALA | Operations Center",description:"TWALA Mobility interactive operations demonstration"};
export default function RootLayout({children}:{children:React.ReactNode}){return <html lang="en"><body>{children}</body></html>}
