import Foundation
import Vision
import ImageIO
import PDFKit
import AppKit
guard CommandLine.arguments.count == 2 else { exit(2) }
let url=URL(fileURLWithPath: CommandLine.arguments[1]); var images:[CGImage]=[]
if url.pathExtension.lowercased()=="pdf", let pdf=PDFDocument(url:url) { for i in 0..<pdf.pageCount { if let page=pdf.page(at:i), let cg=page.thumbnail(of:NSSize(width:2400,height:3200),for:.mediaBox).cgImage(forProposedRect:nil,context:nil,hints:nil) { images.append(cg) } } }
else if let src=CGImageSourceCreateWithURL(url as CFURL,nil), let image=CGImageSourceCreateImageAtIndex(src,0,nil) { images.append(image) }
guard !images.isEmpty else { exit(3) }
do { for (i,image) in images.enumerated() { let request=VNRecognizeTextRequest(); request.recognitionLevel = .accurate; request.recognitionLanguages=["zh-Hans","en-US"]; request.usesLanguageCorrection=true; try VNImageRequestHandler(cgImage:image).perform([request]); print("--- PAGE \(i+1) ---"); print((request.results ?? []).compactMap { $0.topCandidates(1).first?.string }.joined(separator:"\n")) } } catch { fputs("OCR failed: \(error)\n",stderr); exit(4) }
