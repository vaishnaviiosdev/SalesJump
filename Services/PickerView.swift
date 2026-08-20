//
//  PickerView.swift
//  SalesJump
//
//  Created by San eforce on 18/08/26.
//

import SwiftUI
import UIKit

struct YearPicker: UIViewRepresentable {

    @Binding var selectedYear: Int

    private let years = Array(2000...2100)

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UIPickerView {
        let picker = UIPickerView()
        picker.delegate = context.coordinator
        picker.dataSource = context.coordinator

        // Default selection
        if let yearIndex = years.firstIndex(of: selectedYear) {
            picker.selectRow(yearIndex, inComponent: 0, animated: false)
        }

        return picker
    }

    func updateUIView(_ uiView: UIPickerView, context: Context) {
        if let yearIndex = years.firstIndex(of: selectedYear) {
            uiView.selectRow(yearIndex, inComponent: 0, animated: true)
        }
    }

    class Coordinator: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {

        var parent: YearPicker

        init(_ parent: YearPicker) {
            self.parent = parent
        }

        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return parent.years.count
        }

        func pickerView(_ pickerView: UIPickerView,
                        titleForRow row: Int,
                        forComponent component: Int) -> String? {
            return "\(parent.years[row])"
        }

        func pickerView(_ pickerView: UIPickerView,
                        didSelectRow row: Int,
                        inComponent component: Int) {
            parent.selectedYear = parent.years[row]
        }
    }
}
